/*
 * Copyright (C) 2013-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.AircraftType.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.AircraftType',
    'Extgui.Ygg.Acao.AircraftType.View',
  ],
  alias: 'widget.acao_aircraft_type_picker',

  extguiObject: 'Extgui.Ygg.Acao.AircraftType',

  searchIn: [ 'name' ],
  defaultSorter: 0,
  sorters: [
    { label: 'Name', sorter: 'name' },
  ],
});

