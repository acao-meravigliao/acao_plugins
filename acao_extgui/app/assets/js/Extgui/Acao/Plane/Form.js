/*
 * Copyright (C) 2013-2013, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Plane.Form', {
  extend: 'Extgui.form.ModelPanel',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Plane',
  ],
  alias: 'widget.acao_plane_form',

  model: 'Ygg.Acao.Plane',

  items: [
   {
    xtype: 'textfield',
    name: 'flarm_code',
    fieldLabel: 'Codice FLARM',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'owner_name',
    fieldLabel: 'Proprietario',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'home_airport',
    fieldLabel: 'Aeroporto',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'type_name',
    fieldLabel: 'Tipo',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'race_registration',
    fieldLabel: 'Sigle di Gara',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'registration',
    fieldLabel: 'Marche',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'common_radio_frequency',
    fieldLabel: 'Frequenza Radio',
    acl: 'R',
   },
  ],
});
