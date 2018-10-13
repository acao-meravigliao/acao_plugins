/*
 * Copyright (C) 2016-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MeterBus.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.MeterBus',
    'Ext.grid.column.Date',
  ],
  model: 'Ygg.Acao.MeterBus',
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
    dataIndex: 'descr',
    filterable: true,
    searchable: true,
    flex: 2,
   },
   {
    dataIndex: 'ipv4_address',
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'port',
    filterable: true,
    searchable: true,
   },
  ],
  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.meter_bus.index_panel.action.new',
    iconCls: 'icon-add',
   }
  ],
});
