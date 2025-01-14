import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import OmniscriptSetValues from "vlocity_cmt/omniscriptSetValues";

export default class demoSetValueNext extends OmniscriptBaseMixin(OmniscriptSetValues) {
    
    /**
     * Overrides the Set Values 'execute' method to move the OmniScript to the next step
     * @param event  The execution event
     * 
     */
    execute(event) {

        try {

            // Perform regular Set Value operations
            return Promise.resolve(
                super.execute(event)
                .then(result => {
                    // Move to the next Step in OmniScript
                    super.omniNextStep();
                })
                .catch(err => {
                    console.error("Error in demo_setvalue_next.execute().Promise -> " + err);                    
                    return err;
                })
            );
        } catch (err) {
            console.error("Error while executing LWC demo_setvalue_next.execute() -> " + err);
        }
    }
}