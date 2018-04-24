// I_ParameterizedSync
//
// This interface is implemented by sync schedule and sync batch classes to allow one batch to
// send a string parameter to the next batch. For example, this will be used in
// UTIL_CreditLimitSync_* which needs to sync all customer/accounts. The first run will start
// with no parameter, and stop at MAX_ROWS. It will then pass the last customer number it completed
// into the launch of the next scheduled batch, and the next batch will use that customer number
// as a search param so it can continue where the first batch left off
public interface I_ParameterizedSync
{
    void setBatchParam(String value);
}