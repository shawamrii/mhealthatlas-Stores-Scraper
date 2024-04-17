/**
 * com.mhealthatlas.enterprisemanagement contains all functionalities of the
 * enterprise management service. Provided functionalities are creating,
 * updating and deletion of enterprises and enterprise users. Additionally
 * enterprise administrators can be created.
 * <p>
 * Produced Events via Outbox Pattern (topic: event type):
 * <p>
 * Consumed Events (topic: event type):
 * <ul>
 * <li>user-management: user_created
 * <li>user-management: user_updated
 * <li>user-management: user_deleted
 * <li>enterprise-management: group_created
 * <li>enterprise-management: group_deleted
 * </ul>
 */
package com.mhealthatlas.enterprisemanagement;
