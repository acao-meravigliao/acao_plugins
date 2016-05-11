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

Ext.define('Extgui.Acao.Flight.Form', {
  extend: 'Extgui.form.ModelPanel',
  requires: [
    'Extgui.Acao.Plugin',
    'Extgui.form.field.DecimalNumber',
    'Extgui.form.field.DateTime',
    'Ygg.Acao.Flight',
    'Ygg.Acao.Plane',
    'Ygg.Core.Person',
    'Extgui.Core.Person.ReferenceField',
    'Extgui.Acao.Plane.ReferenceField',
  ],
  alias: 'widget.acao_flight_form',

  model: 'Ygg.Acao.Flight',

  items: [
   {
    xtype: 'core_person',
    name: 'plane_pilot1_id',
    fieldLabel: 'Pilota 1 Aliante',
    acl: 'R',
   },
   {
    xtype: 'core_person',
    name: 'plane_pilot2_id',
    fieldLabel: 'Pilota 2 Aliante',
    acl: 'R',
   },
   {
    xtype: 'core_person',
    name: 'towplane_pilot1_id',
    fieldLabel: 'Pilota 1 Traino',
    acl: 'R',
   },
   {
    xtype: 'core_person',
    name: 'towplane_pilot2_id',
    fieldLabel: 'Pilota 2 Traino',
    acl: 'R',
   },

   {
    xtype: 'acao_plane',
    name: 'plane_id',
    fieldLabel: 'Aliante',
    acl: 'R',
   },
   {
    xtype: 'acao_plane',
    name: 'towplane_id',
    fieldLabel: 'Traino',
    acl: 'R',
   },

   {
    xtype: 'datetimefield',
    name: 'takeoff_at',
    fieldLabel: 'Decollo',
    acl: 'R',
   },
   {
    xtype: 'datetimefield',
    name: 'landing_at',
    fieldLabel: 'Atterraggio',
    acl: 'R',
   },
   {
    xtype: 'datetimefield',
    name: 'takeoff_at',
    fieldLabel: 'Atterraggio Traino',
    acl: 'R',
   },

   {
    xtype: 'textfield',
    name: 'dep',
    fieldLabel: 'Aeroporto Partenza',
    acl: 'R',
   },
   {
    xtype: 'textfield',
    name: 'arr',
    fieldLabel: 'Aeroporto Arrivo',
    acl: 'R',
   },

   {
    xtype: 'numberfield',
    name: 'quota',
    fieldLabel: 'Quota',
    acl: 'R',
   },
   {
    xtype: 'decimalnumberfield',
    name: 'bollini_volo',
    fieldLabel: 'Bollini',
    acl: 'R',
   },

  ],
});
