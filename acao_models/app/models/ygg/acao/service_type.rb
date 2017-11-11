#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class ServiceType < Ygg::PublicModel
  self.table_name = 'acao_service_types'

  has_many :person_services,
           class_name: 'Ygg::Acao::PersonService'
end

end
end
