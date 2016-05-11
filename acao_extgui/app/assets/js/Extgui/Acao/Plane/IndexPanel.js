/*
 * Copyright (C) 2014-2014, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Plane.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Plane',
  ],

  title: 'Acao Planes',
  model: 'Ygg.Acao.Plane',
  storeConfig: {
    sorters: {
      property: 'registration',
      direction: 'ASC',
    },
  },
  columns: [
   {
    text: 'Marche',
    dataIndex: 'registration',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    text: 'Sigle Gara',
    dataIndex: 'race_registration',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    text: 'Proprietario',
    dataIndex: 'owner_name',
    filterable: true,
    searchable: true,
    width: 150,
   },
   {
    text: 'Tipo',
    dataIndex: 'type_name',
    filterable: true,
    searchable: true,
    width: 150,
   },
   {
    text: 'Codice FLARM',
    dataIndex: 'flarm_code',
    filterable: true,
    searchable: true,
    width: 150,
   },
  ],
  actions: [
  ],
});
