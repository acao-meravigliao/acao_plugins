#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class PasswordRecoveryController < Ygg::Hel::BaseController
  layout false

  class AccountNotFound < ActiveRest::Controller::Rails::Exception::UnprocessableEntity ; end
  class CredentialNotFound < ActiveRest::Controller::Rails::Exception::UnprocessableEntity ; end
  class ContactNotFound < ActiveRest::Controller::Rails::Exception::UnprocessableEntity ; end

  def recover

    person = Ygg::Core::Person.find_by(acao_code: json_request[:acao_code])
    raise AccountNotFound if !person

    credential = person.credentials.where('fqda LIKE \'%@cp.acao.it\'').first
    raise CredentialNotFound if !credential

    contact = person.contacts.where(type: 'email').first
    raise ContactNotFound if !contact

    Ygg::Ml::Msg.notify(destinations: person, template: 'PASSWORD_RECOVERY', template_context: {
      first_name: person.first_name,
      password: credential.password,
    }, objects: person)

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end

end
end
