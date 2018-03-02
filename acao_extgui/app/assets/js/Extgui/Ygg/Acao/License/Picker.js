/*
 * Copyright (C) 2014-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.License.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.License',
    'Extgui.Ygg.Acao.License.View',
  ],
  alias: 'widget.acao_license_picker',

  extguiObject: 'Extgui.Ygg.Acao.License',

  searchIn: [ 'license' ],
  defaultSortField: 'license',
  sortFields: [
    { label: 'Identifier', field: 'identifier' },
  ],
});

