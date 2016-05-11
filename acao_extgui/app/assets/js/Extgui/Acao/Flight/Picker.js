/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Flight.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Acao.Plugin',
    'Extgui.Acao.Flight',
    'Extgui.Acao.Flight.View',
    'Extgui.Acao.Flight.Form',
  ],
  alias: 'widget.acao_flight_picker',

  extguiObject: 'Extgui.Acao.Flight',

  searchIn: [ 'id' ],
  defaultSortField: 'id',
  sortFields: [
    { label: 'ID', field: 'id' },
  ],
});

