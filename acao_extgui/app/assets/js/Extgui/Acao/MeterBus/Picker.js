/*
 * Copyright (C) 2012-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.MeterBus.Picker', {
  extend: 'Extgui.object.Picker',
  alias: 'widget.acao_meter_bus_picker',
  requires: [
    'Extgui.Acao.Plugin',
    'Extgui.Acao.MeterBus',
    'Extgui.Acao.MeterBus.View',
  ],
  extguiObject: 'Extgui.Acao.MeterBus',

  searchIn: [ 'name', ],
  defaultSorter: 0,
  sorters: [
   { label: 'Name', sorter: 'name' },
  ],
});
