/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Airfield.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Airfield',
    'Extgui.Ygg.Acao.Airfield.View',
  ],
  alias: 'widget.acao_airfield_picker',

  extguiObject: 'Extgui.Ygg.Acao.Airfield',

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});

