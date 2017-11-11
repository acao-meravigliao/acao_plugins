/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Year.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Year',
  ],

  model: 'Ygg.Acao.Year',

  storeConfig: {
    sorters: {
      property: 'year',
      direction: 'ASC',
    },
  },

  columns: [
   {
    dataIndex: 'year',
    flex: 1,
    filterable: true,
    searchable: true,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.year.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
