#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Aircraft::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Aircraft

  skip_before_action :ensure_authenticated_and_authorized!, only: [ :by_code ]

  def by_code
    if match = /([a-z]+):(.*)/.match(params[:id])
      ar_resource = Ygg::Acao::Aircraft.joins(:trackers).where(acao_trackers: { type: match[1].upcase, identifier: match[2].upcase }).first

      if ar_resource
        expires_in 1.hour, public: true
        ar_respond_with(ar_resource)
      else
        head status: 404
      end
    else
      head status: 404
    end
  end
end

end
end
