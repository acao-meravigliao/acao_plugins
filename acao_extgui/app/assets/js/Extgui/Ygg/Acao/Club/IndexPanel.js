/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Club.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Club',
  ],

  title: 'Acao Clubs',
  model: 'Ygg.Acao.Club',
  storeConfig: {
    sorters: {
      property: 'name',
      direction: 'ASC',
    },
  },
  columns: [
   {
    dataIndex: 'name',
    filterable: true,
    searchable: true,
    flex: 1,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.club.index_panel.action.new',
    iconCls: 'icon-add',
   }
  ],
});
