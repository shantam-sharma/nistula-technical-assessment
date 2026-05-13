
# What gets logged

# What happens if no human responds within 30 minutes

___________________________________________________________________________________________________________________________
Question C — The Learning


Answer:
Since this is the third hot water complaint in two months for Villa B1, the system should recognize it as a recurring operational issue instead of treating it as isolated guest feedback. The platform should automatically flag Villa B1 as a “repeat maintenance risk” property and flag the issue to operations management for investigation and finding a permanent solution.
To prevent this complaint from happening a fourth time, the system should:
1. Introduce proactive guest monitoring by sending a quick pre-check message asking guests if all utilities, including hot water, are functioning properly shortly after check-in.
2. Track and analyze complaint patterns by villa, issue type, and time of occurrence to identify recurring operational failures automatically.
3. Build scheduled checks for Villa B1’s water heating system, especially during the hours when complaints are most commonly reported.
4. Add automated alerts or smart reminders for on-duty staff to verify hot water availability before guest peak usage times such as early mornings.
5. Maintain a maintenance history log for each villa so the team can identify whether previous fixes were temporary or ineffective.
6. If repeated failures continue even after maintenance, the system should recommend deeper infrastructure inspection or replacement of the heating equipment instead of repeated short-term fixes.
7. The issue is marked as high priority and assigned to senior maintenance staff instead of standard support handling.
___________________________________________________________________________________________________________________________
# PART 3 — THINKING QUESTION

**SCENARIO:** It is 3am. A guest at Villa B1 sends a WhatsApp message: *"There is no hot water and we have guests arriving for breakfast in 4 hours. This is unacceptable. I want a refund for tonight."*

---

## Question A — The Immediate Response

**What should the AI reply right now at 3am? Write the actual message.**

> We're very sorry for the inconvenience. We completely understand that having no hot water is a major issue, especially with guests arriving in just a few hours. Our maintenance team has been alerted and is treating this as a high priority. You can expect hot water to be available within 30–45 minutes. Management will follow up later this morning to discuss a fair resolution regarding your refund request. Thank you for bringing this to our attention immediately — please let us know if there is anything further we can assist you with in the meantime.

**Why this wording:**

- The response begins with empathy and acknowledgment of the issue to help calm the guest and show that their concern is being taken seriously.
- It clearly communicates immediate action and provides a realistic resolution timeline, which helps rebuild trust and reduce uncertainty.
- The refund request is addressed professionally without making premature promises, while maintaining a calm and hospitality-focused tone.
- The message is kept short and direct to avoid further frustrating the guest during a stressful situation, while still delivering all essential information clearly.
---

## Question B — The System Design

**What should the platform do beyond sending a message?**

### What gets triggered

1. The AI system first classifies the message as a “high-priority maintenance issue” because it contains keywords like “no hot water,” “unacceptable,” and “refund.”
2. A maintenance ticket should automatically be created with details including villa number, timestamp, guest complaint, severity level, and expected urgency.
3. A 30-minute acknowledgment timer is started to track whether a human staff member responds on time.
4. A guest escalation workflow is triggered because the complaint directly impacts the guest experience and stay quality.
5. A refund review workflow is also opened so the compensation request can later be reviewed by management.
6. The guest communication system should continue providing live status updates if the issue is being actively worked on, so the guest does not feel ignored during the resolution process.

### Who gets notified

1. The on-duty maintenance staff and property manager should instantly receive alerts through multiple channels such as WhatsApp, SMS, push notification, or phone call if required because the issue is time-sensitive and happening at 3am.
2. If the issue is not acknowledged quickly, backup maintenance staff and higher-level management should receive escalation alerts automatically.
3. The property manager or operations manager should also be notified immediately for visibility into the incident.
4. The customer support or guest relations team should also be informed so they can manage communication and guest satisfaction professionally.
5. If compensation is likely required, the finance or approval team can be notified to look into the matter.

### What gets logged

1. The original guest complaint and exact timestamp of when it was received.
2. Villa number, issue category, severity level, and priority classification.
3. Staff response times, maintenance actions taken, repair updates, and final resolution status.
4. All guest communication updates shared during the incident process.
5. Whether the guest requested a refund and the final compensation outcome.
6. A complete record of the issue, responses, and actions taken should be stored for future review and to help identify repeated problems.

### If no human responds within 30 minutes

1. If no staff member acknowledges the issue within 30 minutes, the platform should automatically escalate the incident to higher-level management or backup personnel.
2. The system should continue updating the guest transparently during the delay instead of leaving the conversation inactive.
3. If there is still no response, the system should trigger emergency fallback actions such as arranging an alternative villa, partial compensation approval workflow, or priority customer support intervention.
4. After resolution, the system should automatically request an internal incident review to determine why the issue occurred and whether maintenance is required.

---

## Question C — The Learning

**This is the third time in two months a guest has complained about hot water
at Villa B1. What should the system do with this pattern? What would you
build to prevent this complaint from happening a fourth time?**

Since this is the third hot water complaint in two months for Villa B1, the system should recognise it as a recurring operational issue rather than isolated guest feedback. The platform should automatically flag Villa B1 as a "repeat maintenance risk" property and surface it to operations management for investigation and a permanent fix.

### What to build to prevent a fourth complaint

1. Introduce proactive guest monitoring by sending a brief post-check-in message asking if all utilities — including hot water — are functioning correctly.
2. Track and analyse complaint patterns by villa, issue type, and time of day to identify recurring operational failures automatically.
3. Build scheduled maintenance checks for Villa B1's water heating system, particularly during hours when complaints are most commonly reported.
4. Add automated reminders for on-duty staff to verify hot water availability before peak guest usage times, such as early mornings.
5. Maintain a maintenance history log per villa so the team can determine whether previous fixes were temporary or ineffective.
6. If failures continue after maintenance, the system should recommend a deeper infrastructure inspection or equipment replacement rather than another short-term fix.
7. Flag the issue as high priority and assign it to senior maintenance staff rather than standard support handling.
