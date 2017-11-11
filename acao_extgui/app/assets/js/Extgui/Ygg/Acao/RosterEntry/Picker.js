/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterEntry.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.RosterEntry',
    'Extgui.Ygg.Acao.RosterEntry.View',
  ],
  alias: 'widget.acao_roster_entry_picker',

  extguiObject: 'Extgui.Ygg.Acao.RosterEntry',

  searchIn: [ 'id' ],
  defaultSortField: 'id',
  sortFields: [
    { label: 'ID', field: 'id' },
  ],
});

