/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Club.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Club',
    'Extgui.Ygg.Acao.Club.View',
  ],
  alias: 'widget.acao_club_picker',

  extguiObject: 'Extgui.Ygg.Acao.Club',

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});

