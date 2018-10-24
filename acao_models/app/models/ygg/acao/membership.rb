#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Membership < Ygg::PublicModel
  self.table_name = 'acao_memberships'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "invoice_detail_id", type: :uuid, default: nil, null: true}],
    [ :must_have_column, {name: "status", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "valid_from", type: :datetime, default: nil, null: false}],
    [ :must_have_column, {name: "valid_to", type: :datetime, default: nil, null: false}],
    [ :must_have_column, {name: "reference_year_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "email_allowed", type: :boolean, default: true, null: false}],
    [ :must_have_column, {name: "tug_pilot", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "board_member", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "instructor", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "possible_roster_chief", type: :boolean, default: false, null: false}],
    [ :must_have_column, {name: "fireman", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "student", type: :boolean, default: false, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id", "reference_year_id"], unique: true}],
    [ :must_have_index, {columns: ["reference_year_id"], unique: false}],
    [ :must_have_index, {columns: ["invoice_detail_id"], unique: false}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_years", column: "reference_year_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_invoice_details", column: "invoice_detail_id", primary_key: "id", on_delete: :nullify, on_update: nil}],
  ]

  belongs_to :person,
             class_name: '::Ygg::Core::Person'

  belongs_to :invoice_detail,
             class_name: 'Ygg::Acao::Invoice::Detail',
             optional: true

  belongs_to :reference_year,
             class_name: 'Ygg::Acao::Year'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  include Ygg::Core::Notifiable

  before_save do
    if person_id_changed?
      self.class.readables_set_dirty
    end
  end

  def self.compute_completed_years(from, to)
    # Number of completed years is not trivial :)

    completed_years = to.year - from.year

    if from.month > to.month ||
       (from.month == to.month && from.day > to.day)
      completed_years -= 1
    end

    completed_years
  end

  def self.determine_base_context(person:, year:)
    if !person.birth_date
      return { ass_type: 'ASS_STANDARD', cav_type: 'CAV_STANDARD' }
    end

    age = compute_completed_years(person.birth_date, year.renew_opening_time)

    if age < 23
      ass_type = 'ASS_23'
      cav_type = nil
    elsif age <= 26
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_26'
    elsif age >= 75
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_75'
    elsif person.acao_has_disability
      # This supposes CAV_DIS is always equal or more expensive than CAV_75 a CAV_26
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_DIS'
    else
      #if person.residence_location &&
      #   Geocoder::Calculations.distance_between(
      #     [ person.residence_location.lat, person.residence_location.lng ],
      #     [ 45.810189, 8.770963 ]) > 300000

      #  cav_amount = 700.00
      #  cav_type = 'CAV residenti oltre 300 km'
      #else

      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_STANDARD'
    end

    {
     ass_type: ass_type,
     cav_type: cav_type,
    }
  end

  def self.renew(person:, payment_method:, services:, enable_email:, with_cav:)
    payment = nil

    renewal_year = Ygg::Acao::Year.renewal_year
    context = determine_base_context(person: person, year: renewal_year)
    member = person.becomes(Ygg::Acao::Pilot)

    # Invoice -----------------
    invoice = Ygg::Acao::Invoice.create!(
      person: person,
      payment_method: payment_method,
    )

    member.acao_email_allowed = enable_email

    # Association --------------
    ass_service_type = Ygg::Acao::ServiceType.find_by!(symbol: context[:ass_type])

    if person.acao_memberships.find_by(reference_year: renewal_year)
      raise "Membership already present"
    end

    ass_invoice_detail = Ygg::Acao::Invoice::Detail.new(
      service_type: ass_service_type,
      count: 1,
      price: ass_service_type.price,
      descr: ass_service_type.name,
    )
    invoice.details << ass_invoice_detail

    membership = Ygg::Acao::Membership.create!(
      person: person,
      reference_year: renewal_year,
      status: 'WAITING_PAYMENT',
      invoice_detail: ass_invoice_detail,
      valid_from: Time.now,
      valid_to: Time.new(renewal_year.year).end_of_year,
      possible_roster_chief: person.acao_roster_chief,
      student: person.acao_is_student,
      tug_pilot: person.acao_is_tug_pilot,
      board_member: person.acao_is_board_member,
      instructor: person.acao_is_instructor,
      fireman: person.acao_is_fireman,
    )

    # CAV --------------

    if with_cav && context[:cav_type]
      cav_service_type = Ygg::Acao::ServiceType.find_by!(symbol: context[:cav_type])

      cav_invoice_detail = Ygg::Acao::Invoice::Detail.new(
        count: 1,
        service_type: cav_service_type,
        price: cav_service_type.price,
        descr: cav_service_type.name,
      )
      invoice.details << cav_invoice_detail

      cav_member_service = Ygg::Acao::MemberService.create(
        person: person,
        service_type: cav_service_type,
        invoice_detail: cav_invoice_detail,
        valid_from: Time.new(renewal_year.year).beginning_of_year,
        valid_to: Time.new(renewal_year.year).end_of_year,
      )
    end

    # Services
    services.each do |service|
      service_type = Ygg::Acao::ServiceType.find(service[:type_id])

      invoice_detail = Ygg::Acao::Invoice::Detail.new(
        count: 1,
        service_type: service_type,
        price: service_type.price,
        descr: service_type.name,
        data: service[:extra_info],
      )
      invoice.details << invoice_detail

      Ygg::Acao::MemberService.create!(
        person: person,
        service_type: service_type,
        invoice_detail: invoice_detail,
        valid_from: Time.new(renewal_year.year).beginning_of_year,
        valid_to: Time.new(renewal_year.year).end_of_year,
        service_data: service[:extra_info],
      )
    end

    # Done! -------------

    invoice.close!
    payment = invoice.generate_payment!(
      reason: "rinnovo associazione, codice pilota #{person.acao_code}",
      timeout: 10.days,
    )
    payment.save!

    Ygg::Ml::Msg.notify(destinations: person, template: 'MEMBERSHIP_RENEWED', template_context: {
      first_name: person.first_name,
      year: renewal_year.year,
      payment_expiration: payment.expires_at.strftime('%d-%m-%Y'),
    }, objects: [ invoice, payment, membership ])

    membership
  end

  def payment_completed!
    self.status = 'MEMBER'
    save!

    Ygg::Ml::Msg.notify(destinations: person, template: 'MEMBERSHIP_COMPLETE', template_context: {
      first_name: person.first_name,
      year: reference_year.year,
    }, objects: self)
  end

  def active?(time: Time.now)
    ym = Ygg::Acao::Year.find_by(year: year)
    return false if !ym

    time.between?(Time.new(ym.year).beginning_of_year, Time.new(ym.year).ending_of_year)
  end

end

end
end
