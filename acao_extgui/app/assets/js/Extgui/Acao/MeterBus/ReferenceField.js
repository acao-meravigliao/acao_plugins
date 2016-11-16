/*
 * Copyright (C) 2012-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.MeterBus.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Acao.Plugin',
    'Extgui.Acao.MeterBus',
    'Extgui.Acao.MeterBus.Picker',
  ],
  alias: 'widget.acao_meter_bus',

  extguiObject: 'Extgui.Acao.MeterBus',
  pickerClass: 'Extgui.Acao.MeterBus.Picker',
});
