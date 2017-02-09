/*
 * Copyright (C) 2012-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MeterBus.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.MeterBus',
    'Extgui.Ygg.Acao.MeterBus.Picker',
  ],
  alias: 'widget.acao_meter_bus',

  extguiObject: 'Extgui.Ygg.Acao.MeterBus',
  pickerClass: 'Extgui.Ygg.Acao.MeterBus.Picker',
});
