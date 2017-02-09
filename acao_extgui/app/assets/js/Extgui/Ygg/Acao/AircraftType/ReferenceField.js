/*
 * Copyright (C) 2013-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.AircraftType.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.AircraftType',
    'Extgui.Ygg.Acao.AircraftType.Picker',
  ],
  alias: 'widget.acao_aircraft_type',

  extguiObject: 'Extgui.Ygg.Acao.AircraftType',
  pickerClass: 'Extgui.Ygg.Acao.AircraftType.Picker',
});
