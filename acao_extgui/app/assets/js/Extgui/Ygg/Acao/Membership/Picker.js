/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Membership.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Membership',
    'Extgui.Ygg.Acao.Membership.View',
  ],
  alias: 'widget.acao_service_type_picker',

  extguiObject: 'Extgui.Ygg.Acao.Membership',

  searchIn: [ 'membership' ],
  defaultSortField: 'membership',
  sortFields: [
    { label: 'Membership', field: 'membership' },
  ],
});

