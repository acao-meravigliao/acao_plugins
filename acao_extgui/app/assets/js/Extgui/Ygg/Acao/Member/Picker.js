/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Medical.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Medical',
    'Extgui.Ygg.Acao.Medical.View',
  ],
  alias: 'widget.acao_medical_picker',

  extguiObject: 'Extgui.Ygg.Acao.Medical',

  searchIn: [ 'medical' ],
  defaultSortField: 'medical',
  sortFields: [
    { label: 'Identifier', field: 'identifier' },
  ],
});

