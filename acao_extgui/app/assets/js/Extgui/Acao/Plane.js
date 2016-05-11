/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Plane', {
  extend: 'Extgui.object.Base',
  requires: [
    'Extgui.Acao.Plugin',
  ],
  singleton: true,

  model: 'Ygg.Acao.Plane',

  subTpl: [
    '<span class="name">{registration}</span><br />{type_name}',
  ],
});
