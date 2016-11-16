
module Ygg
module Acao

class PlanesController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Plane

  skip_before_action :ensure_authenticated_and_authorized!, :only => [ :by_code ]

  def by_code
    @aaa_context = Ygg::Core::SuperuserContext.new

    @resource_relation ||= ar_model
    @resource_relation = ar_model.includes(ar_model.interfaces[:rest].eager_loading_hints(:view => ar_view)) if ar_model
    @resource = @resource_relation.find_by!(flarm_code: params[:id])

    expires_in 1.hour, :public => true
    respond_with(@resource)
  end
end

end
end
