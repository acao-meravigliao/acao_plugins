/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Aircraft.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Aircraft',
    'Extgui.Ygg.Acao.Aircraft',
    'Extgui.Ygg.Acao.Aircraft.Picker',
  ],
  alias: 'widget.acao_aircraft',

  extguiObject: 'Extgui.Ygg.Acao.Aircraft',
  pickerClass: 'Extgui.Ygg.Acao.Aircraft.Picker',
});
