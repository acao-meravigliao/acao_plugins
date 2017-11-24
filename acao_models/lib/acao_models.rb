#
# Copyright (C) 2008-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'acao_models/version'

module Ygg
module Acao

class ModelsEngine < Rails::Engine
  config.to_prepare do
    Ygg::Core::Person.class_eval do
#      has_one :acao_pilot,
#               class_name: '::Ygg::Acao::Pilot'

      has_many :acao_memberships,
               class_name: '::Ygg::Acao::Membership'

      has_many :acao_payments,
               class_name: '::Ygg::Acao::Payment'

      has_many :acao_roster_entries,
               class_name: '::Ygg::Acao::RosterEntry'

      def acao_send_initial_password
        credential = credentials.where('fqda LIKE \'%@cp.acao.it\'').first

        return if !credential

        Ygg::Ml::Msg.notify(destinations: self, template: 'SEND_INITIAL_PASSWORD', template_context: {
          first_name: first_name,
          password: credential.password,
         }, objects: self)
      end

      def acao_run_notifications
        transaction do
          now = Time.now
          last_run = acao_last_notify_run || Time.new(0)
          when_in_advance_sms = 1.days - 10.hours
          when_in_advance_mail = 7.days - 10.hours

          acao_roster_entries.each do |entry|
            if (entry.roster_day.date.beginning_of_day - when_in_advance_mail).between?(last_run, now)
              Ygg::Ml::Msg.notify(destinations: self, template: 'ROSTER_NEAR_NOTIFICATION', template_context: {
                first_name: first_name,
                date: entry.roster_day.date,
              })
            end

            if (entry.roster_day.date.beginning_of_day - when_in_advance_sms).between?(last_run, now)
              Ygg::Ml::Msg.notify_by_sms(destinations: self, template: 'ROSTER_NEAR_NOTIFICATION_SMS', template_context: {
                first_name: first_name,
                date: entry.roster_day.date,
              })
            end
          end

          self.acao_last_notify_run = now

          save!
        end
      end
    end
  end
end

end
end
