/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Tracker.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Tracker',
    'Extgui.Ygg.Acao.Tracker.View',
  ],
  alias: 'widget.acao_tracker_picker',

  extguiObject: 'Extgui.Ygg.Acao.Tracker',

  searchIn: [ 'identifier' ],
  defaultSortField: 'identifier',
  sortFields: [
    { label: 'Identifier', field: 'identifier' },
  ],
});

