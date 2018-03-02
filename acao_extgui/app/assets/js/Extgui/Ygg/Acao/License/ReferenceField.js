/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.License.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.License',
    'Extgui.Ygg.Acao.License',
    'Extgui.Ygg.Acao.License.Picker',
  ],
  alias: 'widget.acao_license',

  extguiObject: 'Extgui.Ygg.Acao.License',
  pickerClass: 'Extgui.Ygg.Acao.License.Picker',
});
