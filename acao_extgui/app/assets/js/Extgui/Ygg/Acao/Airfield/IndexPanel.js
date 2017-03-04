/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Airfield.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Airfield',
  ],

  title: 'Acao Airfields',
  model: 'Ygg.Acao.Airfield',
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
   {
    dataIndex: 'icao_code',
    filterable: true,
    searchable: true,
    width: 80,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.airfield.index_panel.action.new',
    iconCls: 'icon-add',
   }
  ],
});
