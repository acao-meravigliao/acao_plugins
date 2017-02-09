/*
 * Copyright (C) 2012-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MeterBus.Picker', {
  extend: 'Extgui.object.Picker',
  alias: 'widget.acao_meter_bus_picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.MeterBus',
    'Extgui.Ygg.Acao.MeterBus.View',
  ],
  extguiObject: 'Extgui.Ygg.Acao.MeterBus',

  searchIn: [ 'name', ],
  defaultSorter: 0,
  sorters: [
   { label: 'Name', sorter: 'name' },
  ],
});
