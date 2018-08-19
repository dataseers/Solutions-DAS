import { html, LitElement } from '@polymer/lit-element';
import '../components/hpcc-chart.js';
import { sharedStyles } from '../styles/shared-styles.js';
import '@vaadin/vaadin-ordered-layout/vaadin-horizontal-layout';
import '@polymer/paper-dialog';
import '@polymer/paper-button';
import {Comm} from '../js/Comm.js';
import { repeat } from 'lit-html/lib/repeat';

class DrilldownView extends LitElement {
   

  _render({_charts_data, filter_1, filter_2}) {
    return html`
    ${sharedStyles}          
          
          
    <div style="background-color:gray;width:100%">
      <vaadin-vertical-layout>
      <vaadin-horizonal-layout>
      <span style="background-color:gray; padding: 5px;text-align:center">Drilldown View</span>
      <paper-button style="text-align:center;color:blue" on-click="${() => this.close()}">Close</paper-button> 
      </vaadin-horizonal-layout>

            ${repeat(_charts_data, (item) => html`
                <hpcc-chart  chart_type="${item.chart_type}" 
                    dataset_name="${item.dataset_name}" query_name="${item.query_name}" 
                    chart_title="${item.title} by ${filter_1}"
                    filter_1="${filter_1}"></hpcc-chart>
            `)}

      </vaadin-vertical-layout>
      </div>
    
    `;
  }
  

  constructor () {
    super();
    this._charts_data = [];
  }

  static get properties() {
    return {
      dashboard_id: String,
      filter_1: String,
      filter_2: String,
      _charts_data: Object
    }
  }

  open() {
    this.hidden = false;
    this._init();
  }

  _init() {
    let serviceURL = "http://corp.dataseers.ai:8002/WsEcl/soap/query/roxie/das_dashboard_charts_query.1";
    let serviceContent = {
      "das_dashboard_charts_query.1": {
        "dashboard_id": this.dashboard_id,
        "filter_1": this.filter_1
      }
    };

    Comm.getData(serviceURL, serviceContent, 'dashboard_charts' ,this);

    console.log('init data called: ' + this.dashboard_id +
      ' , Service URL: ' + serviceURL +
      ', Content:  ' + JSON.stringify(serviceContent));
  }

  close() {
    this.hidden = true; 
  }


  receiveData(respType, resp) {
    let dashResult = jsonPath(resp, '$..dashboard_charts_data');
    this._charts_data = dashResult[0].Row;
    console.log(JSON.stringify(this._charts_data));
  }
}

window.customElements.define('drilldown-view', DrilldownView);