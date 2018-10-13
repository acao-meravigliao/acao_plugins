/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Medical.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Medical',
    'Extgui.Ygg.Acao.Medical',
    'Extgui.Ygg.Acao.Medical.Picker',
  ],
  alias: 'widget.acao_medical',

  extguiObject: 'Extgui.Ygg.Acao.Medical',
  pickerClass: 'Extgui.Ygg.Acao.Medical.Picker',
});
