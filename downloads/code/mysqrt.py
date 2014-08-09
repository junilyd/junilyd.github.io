'''
Module for approximating the square root
Input
        x: The number for which the square root is approximated.
output
        s:  The requested square root.
'''
def newton(x,debug=False):
    '''newton(x)'''
    
    from numpy import nan

    x = float(x)
    if x==0.:
        return 0.
    elif x<0.:
        print '*** Error, x must be nonnegative'
        return nan
    assert x>0. and type(x) is float,"Unrecognized input"
    
    s = x/5.
    kmax = 100
    tol = 1.e-14
    for k in range(kmax):
        if debug:
            print "Before iteration %s, s = %20.15f" % (k,s)
        s0 = s
        s = 1./2. * (s + x/s)
        delta_s = s - s0
        if abs(delta_s / x) < tol:
            break
    if debug:
        print "After %s iterations, s = %20.15f" % (k+1,s)
    return s

def test():
    from numpy import sqrt
    import mysqrt

    xvalues =[0., 2., 100., 10000, 1.e-4]
    for x in xvalues:
        print 'Testing with x = %20.15e' % x
        s = mysqrt.newton(x)
        s_numpy = sqrt(x)
        print 's = %20.15e,   numpy.sqrt = %20.15e' \
                % (s, s_numpy)
        assert abs(s-s_numpy) < 1.e-14, \
                'Disagree for x = %20.15e' % x
