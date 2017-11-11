#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment < Ygg::PublicModel
  self.table_name = 'acao_payments'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :payment_services,
           class_name: 'Ygg::Acao::Payment::Service',
           embedded: true

  class Service < Ygg::BasicModel
    self.table_name = 'acao_payment_services'

    belongs_to :payment,
               class_name: 'Ygg::Acao::Payment'

    belongs_to :service_type,
               class_name: 'Ygg::Acao::ServiceType'
  end
end

end
end
