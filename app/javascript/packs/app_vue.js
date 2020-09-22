import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'
import VueMask from 'v-mask'
 
Vue.use(VueResource)
Vue.use(TurbolinksAdapter)
Vue.use(VueMask);

document.addEventListener('turbolinks:load', () => {
 
  var element = document.getElementById("cpf-form")
 
  if (element != null) {
    
    var data = JSON.parse(JSON.stringify(element.dataset));
    var classes = {
      alertError: "alert-danger",
      alertInfo: "alert-info"
    }
 
    var app = new Vue({
      el: element,
      data: function() {
        return { data: data, classes: classes }
      },
      methods: {
        findCPF(cpf) {
          this.$http.get('/consulta', {params:{ cpf: cpf }}).then(response => {
            this.data = JSON.parse(JSON.stringify(response.body));
            this.data.cpf_buscado = this.data.cpf;
          }).catch(error => {
            this.data = JSON.parse(JSON.stringify(error.body));
            this.data.isError = true
          })
        },
        blockCPF(cpf) {
          this.$http.post('/blocks', {block:{ cpf: cpf }}).then(response => {
            this.data = JSON.parse(JSON.stringify(response.body));
          }).catch(error => {
            this.data = JSON.parse(JSON.stringify(error.body));
            this.data.isError = true
          })
        },
        freeCPF(block_id){
          this.$http.delete('/blocks/'+block_id).then(response => {
            this.data = JSON.parse(JSON.stringify(response.body));
          }).catch(error => {
            console.log(error.body)
            this.data = JSON.parse(JSON.stringify(error.body));
            this.data.isError = true
          })
        }
      }
    });
  }
});
