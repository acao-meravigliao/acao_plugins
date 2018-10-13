/*
 * Copyright (C) 2008-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.AircraftType.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.AircraftType',
  ],

  model: 'Ygg.Acao.AircraftType',

  storeConfig: {
    sorters: [
     {
      property: 'manufacturer',
      direction: 'ASC',
     },
     {
      property: 'name',
      direction: 'ASC',
     },
    ],
  },

  columns: [
   {
    dataIndex: 'manufacturer',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'name',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'aircraft_class',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'wingspan',
    width: 100,
    unit: 'm',
    filterable: true,
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'handicap',
    width: 100,
    filterable: true,
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'handicap_club',
    width: 100,
    filterable: true,
   },
  ],
});
