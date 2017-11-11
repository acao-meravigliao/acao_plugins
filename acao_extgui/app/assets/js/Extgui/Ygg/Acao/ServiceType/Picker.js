/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.ServiceType.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.ServiceType',
    'Extgui.Ygg.Acao.ServiceType.View',
  ],
  alias: 'widget.acao_service_type_picker',

  extguiObject: 'Extgui.Ygg.Acao.ServiceType',

  searchIn: [ 'id' ],
  defaultSortField: 'id',
  sortFields: [
    { label: 'ID', field: 'id' },
  ],
});

