
module Ygg
module Acao

class FlightsController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Flight

  view :grid do

    eager_load :plane, :towplane, :towplane_pilot1, :towplane_pilot2, :plane_pilot1, :plane_pilot2

    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:takeoff_at) { show! }
    attribute(:towplane_landing_at) { show! }
    attribute(:landing_at) { show! }
    attribute(:quota) { show! }
    attribute(:bollini_volo) { show! }
    attribute(:plane) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:registration) { show! }
    end
    attribute(:towplane) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:registration) { show! }
    end

    attribute(:towplane_pilot1) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute(:towplane_pilot2) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute(:plane_pilot1) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute(:plane_pilot2) do
      include!
      empty!
      shortcut_capabilities!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    attribute(:plane) do
      include!
    end
    attribute(:towplane) do
      include!
    end

    attribute(:plane_pilot1) do
      include!
    end
    attribute(:plane_pilot2) do
      include!
    end

    attribute(:towplane_pilot1) do
      include!
    end
    attribute(:towplane_pilot2) do
      include!
    end
  end

  scope :glider_flights
  scope :motorglider_flights
  scope :pax_flights
  scope :tow_flights

#  def index
#    prof = RubyProf.profile { super }
#    RubyProf::FlatPrinter.new(prof).print(STDOUT, {})
#  end
end

end
end
