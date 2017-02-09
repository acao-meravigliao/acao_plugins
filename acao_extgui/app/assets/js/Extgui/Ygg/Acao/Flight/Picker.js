/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Flight.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Flight',
    'Extgui.Ygg.Acao.Flight.View',
  ],
  alias: 'widget.acao_flight_picker',

  extguiObject: 'Extgui.Ygg.Acao.Flight',

  searchIn: [ 'id' ],
  defaultSortField: 'id',
  sortFields: [
    { label: 'ID', field: 'id' },
  ],
});

