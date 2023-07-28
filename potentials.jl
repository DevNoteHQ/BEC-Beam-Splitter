function linearBarrierWithAngle(angle, strength, padding=1.0)
    function potentialDef(x,y)
        if y - padding <= x * tan(angle) <= y + padding
            return strength
        else 
            return 0
        end
    end
    return potentialDef
end
