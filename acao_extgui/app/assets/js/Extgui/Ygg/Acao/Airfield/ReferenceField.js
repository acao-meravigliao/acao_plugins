/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Airfield.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Airfield',
    'Extgui.Ygg.Acao.Airfield',
    'Extgui.Ygg.Acao.Airfield.Picker',
  ],
  alias: 'widget.acao_airfield',

  extguiObject: 'Extgui.Ygg.Acao.Airfield',
  pickerClass: 'Extgui.Ygg.Acao.Airfield.Picker',
});
