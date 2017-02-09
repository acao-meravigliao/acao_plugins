/*
 * Copyright (C) 2013-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.AircraftType.PickerButton', {
  extend: 'Extgui.object.PickerButton',
  alias: 'widget.acao_aircraft_type_pickerbutton',
  requires: [
    'Extgui.Ygg.Acao.AircraftType.Picker',
  ],

  pickerClass: 'Extgui.Ygg.Acao.AircraftType.Picker',
});
