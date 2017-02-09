/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Aircraft.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Aircraft',
    'Extgui.Ygg.Acao.Aircraft.View',
  ],
  alias: 'widget.acao_aircraft_picker',

  extguiObject: 'Extgui.Ygg.Acao.Aircraft',

  searchIn: [ 'registration' ],
  defaultSortField: 'registration',
  sortFields: [
    { label: 'Marche', field: 'registration' },
  ],
});

