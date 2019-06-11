// -- copyright
// OpenProject is a project management system.
// Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License version 3.
//
// OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
// Copyright (C) 2006-2013 Jean-Philippe Lang
// Copyright (C) 2010-2013 the ChiliProject Team
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
// See doc/COPYRIGHT.rdoc for more details.
// ++

import {Injectable, Injector} from '@angular/core';
import {StateService, Transition} from "@uirouter/core";
import {KeepTabService} from "core-components/wp-single-view-tabs/keep-tab/keep-tab.service";

interface BackRouteOptions {
  name:string;
  params:{};
  parent:string;
}

@Injectable()
export class BackRoutingService {
  private _backRoute:BackRouteOptions;
  private $state:StateService = this.injector.get(StateService);
  private keepTab:KeepTabService = this.injector.get(KeepTabService);

  constructor(protected injector:Injector) {
  }

  public goBack(preferListOverSplit:boolean = false) {
    if (!this.backRoute) {
      this.$state.go('work-packages.list', this.$state.params);
    } else {
      if (this.keepTab.isDetailsState(this.backRoute.parent)) {
        if(preferListOverSplit) {
          this.$state.go('work-packages.list', this.$state.params);
        } else {
          this.$state.go(this.keepTab.currentDetailsState, this.$state.params);
        }
      } else {
        this.$state.go(this.backRoute.name, this.backRoute.params);
      }
    }
  }

  public sync(transition:Transition) {
    const fromState = transition.from();
    const toState = transition.to();

    // Set backRoute to know where we came from
    if (fromState.name &&
      fromState.data &&
      toState.data &&
      fromState.data.parent !== toState.data.parent) {
      const paramsFromCopy = { ...transition.params('from') };
      this.backRoute = { name: fromState.name, params: paramsFromCopy, parent: fromState.data.parent };
    }
  }

  public set backRoute(route:BackRouteOptions) {
    this._backRoute = route;
  }

  public get backRoute():BackRouteOptions {
    return this._backRoute;
  }
}
