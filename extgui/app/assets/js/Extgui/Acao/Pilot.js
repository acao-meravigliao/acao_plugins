/*
 * Copyright (C) 2016-2016, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Pilot', {
  extend: 'Extgui.object.Base',
  requires: [
    'Extgui.Acao.Plugin',
  ],
  singleton: true,

  model: 'Ygg.Acao.Pilot',

  subTpl: [
    '<span class="name">{person.first_name person.last_name}</span><br />{type_name}',
  ],
});
