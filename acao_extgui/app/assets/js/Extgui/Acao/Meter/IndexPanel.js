/*
 * Copyright (C) 2016-2016, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Meter.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Meter',
    'Ext.grid.column.Date',
    'Ygg.Core.Person',
  ],
  model: 'Ygg.Acao.Meter',
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
    xtype: 'stringtemplatecolumn',
    tpl: '<tpl if="person">{person.first_name} {person.last_name}</tpl>',
    dataIndex: 'person',
    searchable: true,
    searchIn: [ 'person.first_name', 'person.last_name' ],
    width: 250,
   },
  ],
  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.meter.index_panel.action.new:',
    iconCls: 'icon-add',
   }
  ],
});
