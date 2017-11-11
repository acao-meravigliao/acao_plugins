/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterDay.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.RosterDay',
    'Extgui.Ygg.Acao.RosterDay.View',
  ],
  alias: 'widget.acao_roster_day_picker',

  extguiObject: 'Extgui.Ygg.Acao.RosterDay',

  searchIn: [ ],
  defaultSortField: 'date',
  sortFields: [
    { label: 'Date', field: 'date' },
  ],
});

