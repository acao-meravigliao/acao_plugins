#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Invoice::Detail::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Invoice::Detail

  load_role_defs!

  build_member_roles(:blahblah) do |obj|
    aaa_context.auth_person.id == obj.invoice.person_id ? [ :recipient ] : []
  end
end

end
end
