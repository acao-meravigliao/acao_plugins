/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Year.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Year',
    'Extgui.Ygg.Acao.Year.View',
  ],
  alias: 'widget.acao_year_picker',

  extguiObject: 'Extgui.Ygg.Acao.Year',

  searchIn: [ 'year' ],
  defaultSortField: 'year',
  sortFields: [
    { label: 'Year', field: 'year' },
  ],
});

