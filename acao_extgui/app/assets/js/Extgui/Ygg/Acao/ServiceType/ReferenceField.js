/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.ServiceType.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.ServiceType',
    'Extgui.Ygg.Acao.ServiceType',
    'Extgui.Ygg.Acao.ServiceType.Picker',
  ],
  alias: 'widget.acao_service_type',

  extguiObject: 'Extgui.Ygg.Acao.ServiceType',
  pickerClass: 'Extgui.Ygg.Acao.ServiceType.Picker',
});
