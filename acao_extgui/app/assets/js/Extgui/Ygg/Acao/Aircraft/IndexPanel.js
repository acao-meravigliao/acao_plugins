/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Aircraft.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Aircraft',
    'Ygg.Acao.AircraftType',
  ],

  title: 'Acao Aircrafts',
  model: 'Ygg.Acao.Aircraft',
  storeConfig: {
    sorters: {
      property: 'registration',
      direction: 'ASC',
    },
  },
  columns: [
   {
    dataIndex: 'registration',
    filterable: true,
    searchable: true,
    width: 90,
   },
   {
    dataIndex: 'race_registration',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'club.name',
    tpl: '<tpl if="club">{club.name}<tpl else>{fn_home_airport}</tpl>',
    width: 250,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'owner.name',
    tpl: '<tpl if="owner">{owner.fist_name} {owner.last_name}<tpl else>{fn_owner_name}</tpl>',
    width: 150,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'aircraft_type.name',
    tpl: '<tpl if="aircraft_type">{aircraft_type.name}</tpl>',
    filterable: true,
    searchable: true,
    width: 150,
   },
   {
    dataIndex: 'flarm_identifier',
    filterable: true,
    searchable: true,
    width: 150,
   },
   {
    dataIndex: 'icao_identifier',
    filterable: true,
    searchable: true,
    width: 150,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.aircraft.index_panel.action.new',
    iconCls: 'icon-add',
   }
  ],
});
