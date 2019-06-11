import {Injector} from '@angular/core';
import {debugLog} from '../../../../helpers/debug_output';
import {relationCellIndicatorClassName, relationCellTdClassName} from '../../builders/relation-cell-builder';
import {tableRowClassName} from '../../builders/rows/single-row-builder';
import {WorkPackageTableRelationColumnsService} from '../../state/wp-table-relation-columns.service';
import {WorkPackageTable} from '../../wp-fast-table';
import {ClickOrEnterHandler} from '../click-or-enter-handler';
import {TableEventHandler} from '../table-handler-registry';

export class RelationsCellHandler extends ClickOrEnterHandler implements TableEventHandler {

  // Injections
  public wpTableRelationColumns = this.injector.get(WorkPackageTableRelationColumnsService);

  public get EVENT() {
    return 'click.table.relationsCell, keydown.table.relationsCell';
  }

  public get SELECTOR() {
    return `.${relationCellIndicatorClassName}`;
  }

  public eventScope(table:WorkPackageTable) {
    return jQuery(table.container);
  }

  constructor(public readonly injector:Injector,
              table:WorkPackageTable) {
    super();
  }

  protected processEvent(table:WorkPackageTable, evt:JQueryEventObject):boolean {
    debugLog('Handled click on relation cell %o', evt.target);
    evt.preventDefault();

    // Locate the relation td
    const td = jQuery(evt.target).closest(`.${relationCellTdClassName}`);
    const columnId = td.data('columnId');

    // Locate the row
    const rowElement = jQuery(evt.target).closest(`.${tableRowClassName}`);
    const workPackageId = rowElement.data('workPackageId');

    // If currently expanded
    if (this.wpTableRelationColumns.getExpandFor(workPackageId) === columnId) {
      this.wpTableRelationColumns.collapse(workPackageId);
    } else {
      this.wpTableRelationColumns.setExpandFor(workPackageId, columnId);
    }

    return false;
  }
}
