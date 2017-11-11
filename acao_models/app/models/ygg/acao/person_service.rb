#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class PersonService < Ygg::PublicModel
  self.table_name = 'acao_person_services'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :payments,
           class_name: 'Ygg::Acao::Payment'
end

end
end
